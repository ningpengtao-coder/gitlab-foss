xml.entry do
  xml.id      project_issue_url(issue.project, issue)
  xml.link    href: project_issue_url(issue.project, issue)
  xml.title   truncate(issue.title, length: 80)
  xml.updated issue.updated_at.xmlschema
  xml.media   :thumbnail, width: "40", height: "40", url: image_url(avatar_icon_for_user(issue.author))

  xml.author do
    xml.name issue.author_name
    xml.email issue.author_public_email
  end

  xml.summary issue.title
  xml.content issue.description if issue.description
  xml.milestone issue.milestone.title if issue.milestone
  xml.due_date issue.due_date if issue.due_date

  # Specifies a category that the entry belongs to. A entry may have multiple category elements.
  unless issue.labels.empty?
    issue.labels.each do |label|
      xml.category term: label.name, label: label.name
    end
  end

# Names each contributor to the entry. An entry may have multiple contributor elements.
  if issue.assignees.any?
    issue.assignees.each do |assignee|
      xml.contributor do
        xml.name assignee.name
        xml.email assignee.public_email if assignee.public_email
      end
    end
  end
end
