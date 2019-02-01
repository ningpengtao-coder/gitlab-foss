<script>
import _ from 'underscore';
import { GlLoadingIcon, GlButton } from '@gitlab/ui';
import { __ } from '~/locale';
import Icon from '~/vue_shared/components/icon.vue';
import api from '~/api.js';

/**
 * Creates a searchable input.
 *
 * When given a value, it will render it as selected value
 * Otherwise it will render a placeholder for the search
 * input.
 *
 * When the user types, it will trigger an event to allow
 * for API queries outside of the component.
 *
 * When results are returned, it renders a selectable
 * list with the suggestions
 *
 * When no results are returned, it will render a
 * button with a `Create` label. When clicked, it will
 * emit an event to allow for the creation of a new
 * record.
 *
 */
export default {
  name: 'SearchableInput',
  components: {
    GlButton,
    GlLoadingIcon,
    Icon,
  },
  props: {
    value: {
      type: String,
      required: false,
      default: '',
    },
    placeholder: {
      type: String,
      required: true,
    },
    createButtonLabel: {
      type: String,
      required: false,
      default: __('Create'),
    },
    results: {
      type: Array,
      required: false,
      default: () => [],
    },
    isLoading: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      filter: this.value || '',
    };
  },
  watch: {
    filter(newVal) {
      if (!_.isEmpty(newVal)) {
        this.$emit('search', newVal);
      }
    },
  },
  computed: {
    composedCreateButtonLabel() {
      return `${this.createButtonLabel} ${this.filter}`;
    },
    /**
     * The list of suggestions should be open when
     *  loading is true
     *  user changed the filter value
     *  list of results is available
     *  @returns Boolean
     */
    showSuggestions() {
      console.log(!_.isEmpty(this.filter) || this.isLoading || this.results.length);

      return !_.isEmpty(this.filter) || this.isLoading || this.results.length;
    },
    /**
     * Create button is available when
     * - loading is false, filter is set and no results are available
     * @returns Boolean
     */
    shouldRenderCreateButton() {
      return !_.isEmpty(this.filter) && !this.isLoading && !this.results.length;
    },
  },
  methods: {
    clearSearch() {
      this.filter = '';
    },
  },
};
</script>
<template>
  <div>
    <div class="input-group position-relative">
      <icon name="search" class="seach-icon-input"/>

      <input
        type="text"
        class="form-control pl-4"
        :aria-label="placeholder"
        v-model="filter"
        :placeholder="placeholder"
      >
      <gl-button @click="clearSearch" class="btn-transparent clear-search-input">
        <icon name="clear"/>
      </gl-button>
    </div>
    <ul class="list-group" v-if="showSuggestions">
      <li class="list-group-item" v-if="isLoading">
        <gl-loading-icon />
      </li>
      <template v-else-if="results.length" >
        <li v-for="(result, i) in results" :key="i"  class="list-group-item" >
          <slot name="result" :result="result">{{ result }}</slot>
        </li>
      </template>
      <li v-else-if="shouldRenderCreateButton"  class="list-group-item" >
        <gl-button @click="$emit('createClicked', filter)">{{ composedCreateButtonLabel }}</gl-button>
      </li>
    </ul>
  </div>
</template>

<style>
.seach-icon-input {
  position: absolute;
  z-index: 10;
  left: 4px;
  fill: #999999;
  top: 10px;
}

.clear-search-input {
  position: absolute;
  z-index: 10;
  fill: #999999;
  top: 1px;
  right: 0px;
}
</style>
