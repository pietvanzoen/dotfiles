require 'yaml'
require 'date'
require 'fileutils'

class NotesRepo

  def initialize(filepath)
    @filepath = filepath
    File.write(@filepath, '') unless File.exists?(@filepath)
    @notes = fetch_notes
  end

  def find_all(params = {})
    notes = @notes.reject{ |note| note.archived_at }
    if params['book'] then
      notes = notes.select{ |note| note.book == params['book'] }
    end
    notes.sort { |a, b| a.created_at <=> b.created_at }
  end

  def find(params)
    if params['book'] then
      notes = find_all({'book' => params['book']})
    else
      notes = find_all
    end
    if params['id'] then
      notes = notes.select { |n| n.id == params['id'].to_i }
    end
    notes.first
  end

  def create!(params)
    params['id'] = last_id + 1
    new_note = Note.new(params)
    @notes.push(new_note)
    save!
    new_note
  end

  def update!(id, params = {})
    note = find({'id' => id })
    note.update!(params)
    save!
    note
  end

  def archive!(params)
    note = find(params)
    note.archive!
    save!
  end

  def save!
    if File.exists? @filepath then
      FileUtils.cp(@filepath, "#{@filepath}~")
    end
    hashed_notes = @notes.map{ |note| note.to_hash }

    File.write(@filepath, hashed_notes.to_yaml)
    @notes = fetch_notes
  end

  def last_id
    note = @notes.sort_by{ |n| n.id }.reverse.first
    return note.id unless note.nil?
  end

  def fetch_notes
    notes = YAML.load_file(@filepath) || []
    notes.map{ |n| Note.new(n) }
  end

  private :save!, :fetch_notes, :last_id
end


class Note
  attr_reader :id, :book, :created_at, :updated_at, :archived_at, :content
  def initialize(params = {})
    @id = params.fetch('id').to_i
    @book = params.fetch('book')
    @content = params.fetch('content', '')
    @created_at = DateTime.parse(params.fetch('created_at', DateTime.now.to_s))
    @updated_at = DateTime.parse(params.fetch('updated_at', DateTime.now.to_s))
    @archived_at = nil
    if not params.fetch('archived_at', '').empty? then
      @archived_at = DateTime.parse(params['archived_at'])
    end
  end

  def update!(params)
    if params['content'] then
      @content = params['content']
      @updated_at = DateTime.now
    end
    if params['book'] then
      @book = params['book']
      @updated_at = DateTime.now
    end
  end

  def archive!
    @archived_at = DateTime.now
    @updated_at = DateTime.now
  end

  def to_hash
    h = Hash.new
    instance_variables.each do |var|
      h[var.to_s.delete("@")] = instance_variable_get(var).to_s
    end
    h
  end
end
