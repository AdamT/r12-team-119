desc 'Empties tmp/letter_opener'
task 'mail:clear' do
  `rm -rf tmp/letter_opener`
end
