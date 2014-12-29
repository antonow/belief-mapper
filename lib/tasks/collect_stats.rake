namespace :collect_stats do
	desc "get current stats"
  task :get_current_stats => :environment do
  	num_users = User.all.count
		num_comments = Comment.all.count
		current_stat = Stat.create!(user_count: num_users, comment_count: num_comments)

		Belief.all.each do |belief|
			BeliefStat.create!(stat: current_stat,
													belief: belief,
													user_count: belief.user_count,
													avg_conviction: belief.avg_conviction,
													comment_count: Comment.tagged_with(belief.name).count)
		end
		puts "\nCurrent stats successfully collected.\n"
  end
end
