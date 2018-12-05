# Components

## Component Library

Our base Vue components are in the [gitlab-ui](https://gitlab.com/gitlab-org/gitlab-ui) repository. Docs and examples for them are available on [gitlab-ui storybook](https://gitlab-org.gitlab.io/gitlab-ui/).

## Icons

Icons should be added to the [gitlab-svgs project][gitlab-svgs-project]. Once new icons are added, please have the maintainer update the gitlab-svgs dependency on NPM and on gitlab-ce. The gitlab-ee repo will be updated from the automatic CE->EE merge.

### Using icons in HAML

We've built a helper method `sprite_icon(icon_name, size: nil, css_class: '')` to make it easier to reference the sprite icons in HAML.

- **icon_name** should correspond to the SVG sprite name. If you are unsure of the name, you can filter for the icon names using the [GitLab SVG Previewer][svg-previewer]
- **size (optional)** sets the size of the icon. Valid sizes include 16, 24, 32, 48 and 72
- **css_class (optional)** applies additional css classes to the icon.

```
# HAML
= sprite_icon('issues', size: 72, css_class: 'icon-danger')

# will generate the following
<svg class="s72 icon-danger">
  <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/assets/icons.svg#issues"></use>
</svg>
```

### Using icons in Vue

We've built a shared component for icon usage in Vue - [icon.vue][icon-vue].

### Using icons in JavaScript

Import `spriteIcon` from [common_utils.js][common-utils]. Calling `spriteIcon(iconName)` returns the icon HTML, which you can add to your page.

## Illustrations

Illustrations are stored in the [gitlab-svgs project][gitlab-svgs-project]. For consistent sizing and padding they should be wrapped by an `.svg-content` element.

### In HAML

Illustrations can be referenced using the `image_tag` helper.

**Example**

```haml
.svg-content
  = image_tag 'illustrations/merge_requests.svg'
```

### In Vue

We can import SVG content directly, then add it to templates using `v-html`. The SVG content doesn't need Vue's change detection, so we access it using [`$options`][vue-options].

```
<script>
import todosEmptySvg from 'images/illustrations/todos_empty.svg';

export default {
  todosEmptySvg,
};
</script>

<template>
  <div class="svg-content">
    <div v-html="$options.todosEmptySvg"></div>
  </div>
</template>
```

## Graphs

We have a lot of graphing libraries in our codebase to render graphs. In an effort to improve maintainability, new graphs should use [D3.js](https://d3js.org/). If a new graph is fairly simple, consider implementing it in SVGs or HTML5 canvas.

We chose D3 as our library going forward because of the following features:

* [Tree shaking webpack capabilities.](https://github.com/d3/d3/blob/master/CHANGES.md#changes-in-d3-40)
* [Compatible with vue.js as well as vanilla javascript.](https://github.com/d3/d3/blob/master/CHANGES.md#changes-in-d3-40)

D3 is very popular across many projects outside of GitLab:

* [The New York Times](https://archive.nytimes.com/www.nytimes.com/interactive/2012/02/13/us/politics/2013-budget-proposal-graphic.html)
* [plot.ly](https://plot.ly/)
* [Droptask](https://www.droptask.com/)

Within GitLab, D3 has been used for the following notable features

* [Prometheus graphs](https://docs.gitlab.com/ee/user/project/integrations/prometheus.html)
* Contribution calendars


[gitlab-svgs-project]: https://gitlab.com/gitlab-org/gitlab-svgs
[svg-previewer]: http://gitlab-org.gitlab.io/gitlab-svgs/
[icon-vue]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/app/assets/javascripts/vue_shared/components/icon.vue
[common-utils]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/app/assets/javascripts/lib/utils/common_utils.js
[vue-options]: https://vuejs.org/v2/api/#vm-options
