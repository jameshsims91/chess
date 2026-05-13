require_relative '../lib/input_parser'

describe InputParser do
  describe '.parse' do
    it 'correctly converts e2e4 to array indices' do
      expect(InputParser.parse('e2e4')).to eq([[6, 4], [4, 4]])
    end

    it 'handles uppercase inputs gracefully' do
      expect(InputParser.parse('A1H8')).to eq([[7, 0], [0, 7]])
    end

    it 'returns nil for completely invalid text' do
      expect(InputParser.parse('hello')).to nil
    end

    it 'returns nil for out-of-bounds chess coordinates' do
      expect(InputParser.parse('z9e4')).to nil
    end
  end
end