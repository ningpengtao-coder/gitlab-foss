<script>
export default {
  props: {
    namespace: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    pathWithNamespace: {
      type: String,
      required: true,
    },
  },
  computed: {
    namespaceName: function() {
      return `${this.namespace} /`;
    },
    path: function() {
      const { pathWithNamespace } = this;
      return pathWithNamespace.charAt(0) == '/' ? pathWithNamespace : `/${pathWithNamespace}`;
    },
  },
};
</script>
<template>
  <h2 class="d-flex prepend-top-8">
    <a class="text-plain" :href="path">
      <span class="project-full-name append-right-8">
        <span class="namespace-name">{{namespaceName}}</span>
        <span class="project-name">{{name}}</span>
      </span>
    </a>
  </h2>
</template>
