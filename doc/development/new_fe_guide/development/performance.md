# Performance

## Lazy loading

Lazy loading is a method we use to improve the time to first render. This feature is built into GitLab.

```
// no lazy loading
<image src="gitlab.png">

// lazy loading
<image class="lazy" data-src="gitlab.png">
```

Asnchronously loaded content containing lazy loaded images need to instantiate `LazyLoader` and call `searchLazyImages()`.

> Note: The Rails `image_tag` helper will add lazy-loading by default unless `lazy: false` is explicitly provided.

## Online resources

- [WebPage Test][web-page-test] for testing site loading time and size.
- [Google PageSpeed Insights][pagespeed-insights] grades web pages and provides feedback to improve the page.
- [Profiling with Chrome DevTools][google-devtools-profiling]
- [Browser Diet][browser-diet] is a community-built guide that catalogues practical tips for improving web page performance.
- [High Performance Animations][high-performance-animations]

[web-page-test]: http://www.webpagetest.org/
[pagespeed-insights]: https://developers.google.com/speed/pagespeed/insights/
[google-devtools-profiling]: https://developers.google.com/web/tools/chrome-devtools/profile/?hl=en
[browser-diet]: https://browserdiet.com/
[high-performance-animations]: https://www.html5rocks.com/en/tutorials/speed/high-performance-animations/

## Monitoring

We have a performance dashboard available in one of our [grafana instances](https://dashboards.gitlab.net/d/1EBTz3Dmz/sitespeed-page-summary?orgId=1). This dashboard automatically aggregates metric data from [sitespeed.io](https://sitespeed.io) every 6 hours. These changes are displayed after a set number of pages are aggregated.

These pages can be found inside a text file in the gitlab-build-images [repository](https://gitlab.com/gitlab-org/gitlab-build-images) called [gitlab.txt](https://gitlab.com/gitlab-org/gitlab-build-images/blob/master/scripts/gitlab.txt)
Any frontend engineer can contribute to this dashboard. They can contribute by adding or removing urls of pages from this text file. Please have a [frontend monitoring expert](https://about.gitlab.com/team) review your changes before assigning to a maintainer of the `gitlab-build-images` project. The changes will go live on the next scheduled run after the changes are merged into `master`.

There are 3 recommended high impact metrics to review on each page

* [First visual change](https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint)
* [Speed Index](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)
* [Visual Complete 95%](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)

For these metrics, lower numbers are better as it means that the website is more performant.
