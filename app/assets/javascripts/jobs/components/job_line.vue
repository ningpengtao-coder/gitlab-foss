<script>
import Icon from '~/vue_shared/components/icon.vue';

export default {
  props: {
    line: {
      type: Object,
      required: false,
      default: ()=> {}
    },
    // lineNumber: {
    //   type: Number,
    //   required: true,
    // },
    // isHeader: {
    //   //on click?
    // },
    // iconName: {
    //   type: String,
    //   required: true,
    //   default: false,
    // },
    // content: {
    //   type: Array,
    //   required: true,
    // },
    // duration: {
    //   type: String,
    //   required: false,
    //   default: null,
    // },
  },
  components: {
    Icon,
  },
};
</script>

<template>
  <div class="line">
    <a>{{ line.lineNumber + 1 }}</a>
    <span v-for="(content, i) in line.content" :key="i">
      {{ content.text }}
    </span>
  </div>
</template>