<script>
import _ from 'underscore';
import { escapeRegExp } from '../../lib/utils/text_utility';

export default {
  props: {
    text: {
      type: String,
      required: true,
    },
    symbols: {
      type: Array,
      required: false,
      default: () => ['/'],
    },
  },
  computed: {
    displayText() {
      const appendWordBreak = (str, symbol) =>
        str.replace(new RegExp(`(${symbol})`, 'g'), `$1<wbr>`);
      return _.uniq(this.symbols)
        .map(escapeRegExp)
        .reduce(appendWordBreak, _.escape(this.text));
    },
  },
};
</script>

<template>
  <span class="text-break" v-html="displayText"></span>
</template>
