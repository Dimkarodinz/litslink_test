class AddPermalinkToPosts < ActiveRecord::Migration[5.1]
  def up
    add_column :posts, :permalink, :string, unique: true, comment: 'Permalink depends on posts.title'
    add_index :posts, :permalink, unique: true

    update_each_post_permalink
  end

  def down
    remove_index :posts, :permalink
    remove_column :posts, :permalink, :string
  end

  private

  def update_each_post_permalink
    Post.find_each do |post|
      next if post.title.blank?

      unique_title = post.title + ' ' + SecureRandom.hex(6) 
      post.permalink = unique_title.parameterize
      post.save(validate: false)
    end
  end
end
