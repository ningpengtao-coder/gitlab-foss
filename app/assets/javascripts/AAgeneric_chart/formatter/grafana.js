{
  source: {
    $path: 'series[]',
      name: {
      $path: 'target',
    },
    data: {
      $path: 'datapoints',
    },
  },
}