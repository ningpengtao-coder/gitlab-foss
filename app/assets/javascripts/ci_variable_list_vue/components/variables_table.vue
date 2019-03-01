<script>
import Variable from './variable.vue';

export default {
  components: {
    Variable,
    EnvironmentScopeHeader: () =>
      import('ee_component/ci_variable_list_vue/components/environment_scope_header.vue'),
  },
  props: {
    variables: {
      type: Array,
      required: true,
    },
    endpoint: {
      type: String,
      required: true,
    },
    valuesVisible: {
      type: Boolean,
      required: true,
    },
    setModalVariable: {
      type: Function,
      required: true,
    },
  },
};
</script>

<template>
  <div>
    <template v-if="variables.length > 0">
      <div class="table-responsive variables-list">
        <div role="row" class="gl-responsive-table-row table-row-header">
          <div role="rowheader" class="table-section section-15">
            {{ s__('Variables|Type') }}
          </div>
          <div role="rowheader" class="table-section section-20">
            {{ s__('Variables|Key') }}
          </div>
          <div role="rowheader" class="table-section section-20">
            {{ s__('Variables|Value') }}
          </div>
          <div role="rowheader" class="table-section section-15">
            {{ s__('Variables|Protected') }}
          </div>
          <div role="rowheader" class="table-section section-15">
            {{ s__('Variables|Masked') }}
          </div>
          <environment-scope-header />
        </div>
        <variable
          v-for="variable in variables"
          :key="variable.id"
          :variable="variable"
          :value-visible="valuesVisible"
          :set-modal-variable="setModalVariable"
        />
      </div>
    </template>
    <div v-else class="settings-message text-center">
      {{ s__('Variables|No variables found. Create one with the button below.') }}
    </div>
  </div>
</template>
