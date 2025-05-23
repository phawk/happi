namespace :spam do
  desc "Check threads without user responses for spam and update spam scores"
  task check_threads: :environment do
    # Find all message threads that don't have any messages from users
    puts "Finding message threads without user responses..."

    total_threads = 0
    updated_threads = 0

    MessageThread.where(spam_score: nil).find_each do |thread|
      total_threads += 1

      # Check if thread has any messages from a user
      has_user_response = thread.messages.where(sender_type: "User").exists?

      # Only process threads without user responses
      unless has_user_response
        # Get the first message in the thread (usually from a customer)
        first_message = thread.messages.order(created_at: :asc).first

        if first_message && first_message.customer?
          puts "Processing thread ##{thread.id} with first message ##{first_message.id}..."

          # Run spam detection on the first message
          team = thread.team
          agent = SpamDetectAgent.new(message: first_message, team: team)

          begin
            spam_result = agent.perform!
            if spam_result.success?
              spam_score = spam_result.value!
              # Update message and thread with spam score
              first_message.update(spam_score: spam_score)
              thread.update(spam_score: spam_score)

              updated_threads += 1
              puts "Updated thread ##{thread.id} with spam score: #{spam_score}"
            end

            # Add a small delay to avoid rate limiting on the AI API
            sleep 0.5
          rescue => e
            puts "Error processing thread ##{thread.id}: #{e.message}"
          end
        end
      end

      # Log progress every 50 threads
      if (total_threads % 50).zero?
        puts "Processed #{total_threads} threads so far, updated #{updated_threads}..."
      end
    end

    puts "Finished processing #{total_threads} threads. Updated #{updated_threads} threads with spam scores."
  end
end
