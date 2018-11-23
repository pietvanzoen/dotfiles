require_relative 'pnote_lib'
require 'yaml'
require 'test/unit'
require 'securerandom'
require 'tempfile'

class TestNote < Test::Unit::TestCase

  def setup
    @content = 'foo bar baz'
    @book = 'wibble'
    @note = Note.new({'id' => '1', 'book' => @book, 'content' => @content})
  end

  def test_initialize
    assert_not_nil(@note.id)
    assert_equal(@note.id, @note.id.to_i)
    assert_equal(@book, @note.book)
    assert_equal(@content, @note.content)
    assert_equal(DateTime.now.to_s, @note.created_at.to_s)
    assert_equal(DateTime.now.to_s, @note.updated_at.to_s)
    assert_equal(nil, @note.archived_at)
  end

  def test_update!
    new_data = {
      'content' => 'foo bar',
      'book' => 'foo'
    }
    old_updated = @note.updated_at
    @note.update!(new_data)
    assert_equal(new_data['content'], @note.content)
    assert_equal(new_data['book'], @note.book)
    assert_not_equal(old_updated, @note.updated_at)
  end

  def test_archive
    old_updated_at = @note.updated_at
    @note.archive!
    assert_equal(DateTime.now.to_s, @note.archived_at.to_s)
    assert_not_equal(old_updated_at, @note.updated_at)
  end

  def test_to_hash
    h = @note.to_hash
    assert_equal(@note.id, h['id'].to_i)
    assert_equal(@note.book, h['book'])
    assert_equal(@note.content, h['content'])
    assert_equal(@note.created_at.to_s, h['created_at'])
    assert_equal(@note.updated_at.to_s, h['updated_at'])
    assert_equal('', h['archived_at'])
  end

end

class TestNotesRepo < Test::Unit::TestCase
  def setup
    @file = Tempfile.new(['test', '.yaml'])
    @note_jan = Note.new({'id' => '1', 'book' => 'git',  'content' => 'jan', 'created_at' => DateTime.parse('2018-01-01').to_s})
    @note_feb = Note.new({'id' => '2', 'book' => 'git',  'content' => 'feb', 'created_at' => DateTime.parse('2018-02-01').to_s})
    @note_mar = Note.new({'id' => '3', 'book' => 'bash', 'content' => 'mar', 'created_at' => DateTime.parse('2018-03-01').to_s})
    @note_archived = Note.new({'id' => '4', 'book' => 'bash', 'content' => 'archived', 'created_at' => DateTime.parse('2018-03-01').to_s, 'archived_at' => DateTime.now.to_s})
    @active_notes = [@note_feb.to_hash, @note_jan.to_hash, @note_mar.to_hash]
    @all_notes = [@note_archived.to_hash].concat(@active_notes)
    @file.write(@all_notes.to_yaml)
    @file.close
    @repo = NotesRepo.new(@file.path)
  end

  def teardown
    @file.unlink
  end

  def test_find_all
    notes = @repo.find_all
    assert_equal(@active_notes.count, notes.length)
    assert(notes[1].instance_of?(Note), 'creates Note objects')
    assert_equal(notes[0].id, @note_jan.id, 'sorted in date order')
    assert_equal(notes[1].id, @note_feb.id, 'sorted in date order')
    assert_equal(notes[2].id, @note_mar.id, 'sorted in date order')
  end

  def test_find_all_book
    git_notes = @repo.find_all({'book' => 'git'})
    assert_equal(git_notes[0].id, @note_jan.id)
    assert_equal(git_notes[1].id, @note_feb.id)
    assert_equal(git_notes.length, 2)
  end

  def test_find_note_id
    note = @repo.find({'id' => @note_mar.id})
    assert_equal(@note_mar.content, note.content)
  end

  def test_create!
    params = {'book' => 'bash', 'content' => SecureRandom.alphanumeric}
    @repo.create!(params)
    assert_equal(@active_notes.count+1, @repo.find_all.length)
    assert_equal(params['content'], @repo.find_all[3].content)

    notes = YAML.load_file(@file.path)
    assert_equal(notes.length, @all_notes.count+1)
  end

  def test_update!
    params = { 'content' => 'it snows in jan', 'book' => 'foo' }
    @repo.update!(@note_jan.id, params)
    note = @repo.find({'id' => @note_jan.id})
    assert_equal(params['content'], note.content)
    assert_equal(params['book'], note.book)

    notes = YAML.load_file(@file.path)
    saved_note = notes.select{ |n| n['id'].to_i == @note_jan.id}.first
    assert_equal(params['content'], saved_note['content'])
    assert_equal(params['book'], saved_note['book'])
  end

  def test_archive!
    @repo.archive!({'id' => @note_feb.id})
    assert_equal(@active_notes.count-1, @repo.find_all.count)

    notes = YAML.load_file(@file.path)
    archived_note = notes.select{ |n| n['id'].to_i == @note_feb.id}.first
    assert_equal(DateTime.now.to_s, archived_note['archived_at'])
  end
end
