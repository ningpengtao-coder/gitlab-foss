{
  source: {
    $path: 'results[].series[]',
      name: {
      $path: '$item',
        $formatting(item) {
        return item[0].name;
      },
    },
    data: {
      $path: '$item',
        $formatting(item) {
        return item[0].values.map((value) => {
          return [new Date(value[0]), value[1]];
        });
      },
    },
  },
}
