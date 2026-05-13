module InputParser
  FILE_MAP = {
    'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
    'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7
  }.freeze

  RANK_MAP = {
    '8' => 0, '7' => 1, '6' => 2, '5' => 3, 
    '4' => 4, '3' => 5, '2' => 6, '1' => 7
  }.freeze

  def self.parse(input)
    clean_input = input.to_s.strip.downcase

    return nil unless clean_input.match?(/^[a-h][1-8][a-h][1-8]$/)

    start_file, start_rank, end_file, end_rank = clean_input.chars

    start_coords = [RANK_MAP[start_rank], FILE_MAP[start_file]]
    end_coords   = [RANK_MAP[end_rank], FILE_MAP[end_file]]

    [start_coords, end_coords]
  end
end