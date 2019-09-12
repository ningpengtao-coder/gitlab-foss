export default {
  source: {
    $path: 'results[].series[]',
    name: {
      $path: 'name',
    },
    data: {
      $path: 'values',
      $formatting: (foo) => {
        return foo;
      },
    },
  },
};