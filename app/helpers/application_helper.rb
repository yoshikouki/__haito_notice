module ApplicationHelper
  # ページごとに完全なタイトルを返す
  def full_title(page_title = "")
    base_title = "配当ノーティス"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
