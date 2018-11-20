# Global navigation

[Introduced](https://gitlab.com/gitlab-com/gitlab-docs/merge_requests/362)
in November 2018, the global nav loops through all pages in the docs site,
outputting in the nav the pages according to frontmatter entries with key/values
specifying the position in the nav.

## How it works

The global nav has 3 components:

- **Section**
  - Category
    - Link

These entries are defined in the document frontmatter:

```md
---
nav_section: admin
nav_category: instance
---

# Install
```

The configuration above adds the "Install" doc to the nav section "Administrator",
under the "Instance" category. The output is:

```md
- Administrator
  - Instance
    - [Install](link)
```

### Sections

The `nav_section` frontmatter entry sets the section a category will be under.

The available sections are:

| Section slug  | Output        |
| ------------- | ------------- |
| `user`        | User          |
| `admin`       | Administrator |
| `development` | Contributor   |

### Categories

The `nav_category` frontmatter entry sets the category of the nav under one of its sections.

Available categories for the `user` section (resembles the UI):

| Category slug | Output     |
| ------------- | ---------- |
| `essentials`  | Essentials |
| `ci`          | CI/CD      |
| `account`     | Account    |
| `operations`  | Operations |
| `registry`    | Registry   |
| `packages`    | Packages   |
| `wiki`        | Wiki       |
| `settings`    | Settings   |
| `general`     | General    |

Example:

```yaml
nav_section: user
nav_category: essentials
```

Available categories for the `admin` section:

| Category slug  | Output     |
| -------------- | ---------- |
| `instance`     | Instance   |
| `settings`     | Settings   |

Example:

```yaml
nav_section: admin
nav_category: general
```

Available categories for the `development` section: none. In this particular case, while
there's no reason to create different categories for the development guides,
`nav_category: ""` is empty, so that all the docs are listed directly under
the `development` section.

Example:

```yaml
nav_section: development
nav_category: ""
```

### Positioning a document within a category

The optional frontmatter entry `nav_category_position` sets the position of the link
in the category list. With it, it's possible to customize the order of the links
within a category. For example, in the section `user`, category `essentials`,
the link to "projects" comes first. This was determined by setting a specific
order for this doc.

Example:

```yaml
nav_section: user
nav_category: essentials
nav_category_position: -1
```

Negative values shift the document to the top of the list, while positive
values push the docs to the bottom.

The docs which do not have any order set defaults to `0`, and will be included
after the docs with negative values. Documents with the same order will
be sorted alphabetically.

For example, consider that we have these documents in the same category:

- Alpha (order = -2)
- Beta (order = -1)
- Delta (order = 1)
- Gama (order = 2)
- Kapa (no order defined)
- Zeta (no order defined)

Output:

- Section
  - Category
    - Alpha (order = -2)
    - Beta (order = -1)
    - Kapa (order = 0)
    - Zeta (order = 0)
    - Delta (order = 1)
    - Gama (order = 2)


Therefore, **only define a document order**:

- To shift documents to the top (with negative values)
- To push documents to the bottom (with positive values)

### Document title

The `nav_title` entry sets a custom title for the nav link. The fallback is
the document title. It's useful to keep the nav with short names and
concise/consistent layout.

Example:

```md
---
nav_section: admin
nav_category: instance
nav_title: "Install"
---

# Installing GitLab on Bla Bla Bla Bla
```

Output:

```md
- Admin docs
  - Instance
    - [Install](link)
```

## Further settings

There are two files that define the global navigation:

- A layout file: `layouts/global_nav.html`
- A Nanoc helper: `lib/helpers/nav.rb`

### Customizing the categories order

For customizing the order of the categories within a section, look for the
`NAV_SECTION_CONFIG` in the helper file `nav.rb`, and set the order accordingly:

```ruby
NAV_SECTION_CONFIG = {
  # Sets the order of the categories in the "user" section.
  # In this case, `essentials` comes first, then `ci`, then `operations`,then `account`, and then `general`.
  'user' => {
    'category_order' => %w{essentials ci operations account general}
  }
}
```

Do this carefully, as the array of categories needs to match all the categories
set through the documents. If you add another category, make sure to add it to this list.
In case there's a category missing in the array, the build will fail.

### Global nav layout

The layout of the nav is defined by the file `global-nav.html`. In this file,
the sections are organized individually.

Each section has two compenents: the highest-level document, and all the rest.

The highest-level document has a unique section slug defined:

- User documentation: `user_main`
- Administration documentation: `admin_main`
- Development documentation: `development_main`

The unique (highest-level) doc is followed by the loop through all the docs
within a section of the nav. For example, for the user docs:

```erb
<!-- User docs -->
<span class="global-nav-block-top">
  <%= nav_create_links_for(sections, 'user_main', @item) %>
</span>
<%= nav_create_links_for(sections, 'user', @item) %>
```

The span tag outputs the highest-level user documentation (`user_main`),
and the subsequent loop outputs all the docs under the `user` section.

To create a new section:

1. Select the highest-level document and add the following to its frontmatter:

    ```yml
    nav_section: section_main
    nav_category: ""
    ```

1. Define a new section slug, e.g., `section`
1. Add to the `global-nav.html` layout:

    ```erb
    <!-- User docs -->
    <span class="global-nav-block-top">
      <%= nav_create_links_for(sections, 'section_main', @item) %>
    </span>
    <%= nav_create_links_for(sections, 'section', @item) %>
    ```

1. To include docs into this new section, add this to their frontmatter:

    ```yaml
    nav_section: section
    nav_category: category-name
    ```

Note that the category is created by the frontmatter entry itself, although,
if you want to define a specific order for the categories within a section, or if
the section already has its categories ordered, the new category needs to
added to the helper, as explained above on [customizing the categories order](#customizing-the-categories-order).

### Category slugs

The nav categories are defined in the frontmatter as slugs, converted to their names
by adding their corresponding labels in the helper file. The fallback is the slug itself,
capitalized.

For example, for the category slug `general`, the category output on the nav is "General".
In this case, there's no label definition for the slug, so the code only capitalizes it.

On the other hand, for the category slug `ci`, the category output on the nav is "CI/CD".
In this case, the slug is defined in the helper file by indicating a label for the slug:

```ruby
NAV_CATEGORY_CONFIG = {
  'ci' => {
    'label' => 'CI/CD'
  }
}
```

Let's say you need to create a category called "Q&A" under the section "User".

The doc frontmatter would contain:

```yaml
nav_section: user
nav_category: qa
```

And you'd have to define a corresponding label for the slug in the helper:

```ruby
NAV_CATEGORY_CONFIG = {
  #...
  'qa' => {
    'label' => 'Q&A'
  }
}
```

As for the `user` section, there's a defined category order, so you also must add the new
category to the array in the helper file:

```ruby
NAV_SECTION_CONFIG = {
  #...
  'user' => {
    'category_order' => %w{essentials ci operations account general qa}
  }
}
```

This way, you're not only including the new category `qa` into the section, but outputting
it after `general`.

## Adding new items to the global nav

To add a new doc to the nav, first and foremost, check with the technical writing team:

- If it's applicable
- What's the exact position the doc will be added to the nav

Once you get their approval and their guidance in regards to the position on the nav,
add to the document you want to include in the nav the following items to its
frontmatter, replacing "section", "category", "title", and "n" accordingly:

```yaml
nav_section: section # the section of the nav the doc will be included into
nav_category: category # the category of the nav the link will fall under
nav_title: "Title" # the name representing the doc in the list (optional)
nav_category_position: n # the order the doc will display on the list (optional)
```

Example:

```yaml
nav_section: admin
nav_category: instance
nav_title: "Install"
nav_category_position: -2
```

Don't forget to ask a technical writer to review your changes before merging.
