require 'spec_helper'

describe Moister do
  def make_subc_parser
    Moister::SubcommandOptionParser.new do |op|
      op.banner = 'blah'

      op.on '-o stuff', 'global opt', 'opt'

      op.subcommand 'subc', 'subc description' do |subop|
        subop.on '-s stuff', 'subc opt', 'subopt'
      end
    end
  end

  it 'has a version number' do
    expect(Moister::VERSION).not_to be nil
  end

  it 'supports config setting shortcut of #on' do
    parsed = Moister::SubcommandOptionParser.new do |op|
      op.on '-o stuff', 'opt'
    end.parse ['-o', 'val' ]

    expect(parsed).to have_attributes(command: nil, positionals: [], config: { 'opt' => 'val' })
  end

  it 'supports subcommand with option set via #on shortcut' do
    parsed = make_subc_parser.parse ['-o', 'val', 'subc', '-s', 'subval', 'positional']

    expect(parsed).to have_attributes(
      command: 'subc',
      positionals: ['positional'],
      config: { 'opt' => 'val', 'subc' => { 'subopt' => 'subval' } }
    )
  end

  it 'supports subcommand aliases' do
    parsed = Moister::SubcommandOptionParser.new do |op|
      op.subcommand 'subc,s', 'subc description'
    end.parse ['s']

    expect(parsed).to have_attributes(command: 'subc')
  end

  it 'supports subcommand positional' do
    parsed = Moister::SubcommandOptionParser.new do |op|
      op.subcommand 'subc param', 'subc description'
    end.parse ['subc', 'paramvalue']
    expect(parsed).to have_attributes(config: { 'subc' => { 'param' => 'paramvalue' } })
  end

  it 'supports subcommand optional positional' do
    parser = Moister::SubcommandOptionParser.new do |op|
      op.subcommand 'subc [param]', 'subc description'
    end
    expect(parser.parse ['subc', 'paramvalue']).to have_attributes(config: { 'subc' => { 'param' => 'paramvalue' } })
    expect(parser.parse ['subc']).to have_attributes(config: { 'subc' => {} })
  end

  it 'supports subcommand repeated positional' do
    parsed = Moister::SubcommandOptionParser.new do |op|
      op.subcommand 'subc *params', 'subc description'
    end.parse ['subc', 'param1', 'param2']
    expect(parsed).to have_attributes(config: { 'subc' => { 'params' => ['param1', 'param2'] } })
  end

  it 'supports subcommand optional repeated positional' do
    parser = Moister::SubcommandOptionParser.new do |op|
      op.subcommand 'subc [*params]', 'subc description'
    end
    expect(parser.parse ['subc', 'p1', 'p2']).to have_attributes(config: { 'subc' => { 'params' => ['p1', 'p2'] } })
    expect(parser.parse ['subc']).to have_attributes(config: { 'subc' => { 'params' => [] } })
  end

  it 'generates help string including subcommand' do
    help_str = make_subc_parser.to_s
    expect(help_str).to eq("blah\n    -o stuff                         global opt\n\ncommands:\n    subc    subc description\n")
  end
end
