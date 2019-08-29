<script>
import Icon from '~/vue_shared/components/icon.vue';

export default {
  props: {
    line: {
      type: Object,
      required: false,
      default: ()=> {}
    },
    isHeader: {
      type: Boolean,
      required: false,
      default: false,
    }
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
  methods: {
    handleRowClick() {

    }
  }
};
</script>

<template>
  <button type="button" class="line" @onClick="handleRowClick">
    <a>{{ line.lineNumber + 1 }}</a>
    <span v-for="(content, i) in line.content" :key="i">
      {{ content.text }}
    </span>
  </div>
</template>