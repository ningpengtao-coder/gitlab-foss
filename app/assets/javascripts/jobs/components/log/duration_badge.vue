<script>
export default {
  props: {
    duration: {
      type: String,
      required: true,
    },
  },
};
</script>
<template>
  <div class="duration rounded align-self-start pr-2 pl-2 ml-2 flex-shrink-0">{{ duration }}</div>
</template>
