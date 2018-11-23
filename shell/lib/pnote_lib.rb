require 'yaml'
require 'date'
require 'securerandom'
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

  def find(params = {})
    if params['book'] then
      notes = find_all({'book' => params['book']})
    else
      notes = find_all
    end
    if params['note_index'] then
      notes = notes.select.with_index { |n, index| index == params.fetch('note_index')}
    end
    if params['id'] then
      notes = notes.select { |n| n.id == params['id'] }
    end
    notes.first
  end

  def create!(params)
    new_note = Note.new(params)
    @notes.push(new_note)
    save!
    new_note
  end

  def update!(id, params = {})
    note = find({'id' => id })
    if params['content'] then
      note.content = params['content']
    end
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

  def fetch_notes
    notes = YAML.load_file(@filepath) || []
    notes.map{ |n| Note.new(n) }
  end

  private :save!, :fetch_notes
end


class Note
  attr_reader :id, :book, :created_at, :updated_at, :archived_at
  def initialize(params = {})
    @id = params.fetch('id', SecureRandom.uuid)
    @book = params.fetch('book')
    @content = params.fetch('content', '')
    @created_at = DateTime.parse(params.fetch('created_at', DateTime.now.to_s))
    @updated_at = DateTime.parse(params.fetch('updated_at', DateTime.now.to_s))
    @archived_at = nil
    if not params.fetch('archived_at', '').empty? then
      @archived_at = DateTime.parse(params['archived_at'])
    end
  end

  def content=(content = '')
    @content = content
    @updated_at = DateTime.now
  end

  def content
    @content
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
