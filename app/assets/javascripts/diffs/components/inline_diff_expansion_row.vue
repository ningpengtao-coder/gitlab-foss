<script>
import Icon from '~/vue_shared/components/icon.vue';
import { MATCH_LINE_TYPE } from '../constants';

export default {
  components: {
    Icon,
  },
  props: {
    line: {
      type: Object,
      required: true,
    },
  },
  computed: {
    isMatchLine() {
      return this.line.type === MATCH_LINE_TYPE;
    },
  },
  methods: {
    handleExpandUpLines() {
      console.log('expand up');
    },
    handleShowAllLines() {
      console.log('show all');
    },
    handleExpandDownLines() {
      console.log('expand down');
    },
  },
};
</script>

<template>
  <tr v-if="isMatchLine" class="line_expansion">
    <td colspan="3">
      <div class="content">
        <a @click="handleExpandUpLines" class="cursor-pointer">
          <icon
            :size="12"
            name="expand-left"
            aria-hidden="true"
            style="transform: rotate(270deg);"
          />
          <span>Expand Up</span>
        </a>
        <a class="mx-2 cursor-pointer" @click="handleShowAllLines">
          <span>Show all</span>
        </a>
        <a class="cursor-pointer" @click="handleExpandDownLines">
          <icon
            :size="12"
            name="expand-left"
            aria-hidden="true"
            style="transform: rotate(90deg);"
          />
          <span>Expand Down</span>
        </a>
      </div>
    </td>
  </tr>
</template>
