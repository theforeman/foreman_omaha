import React from 'react';
// eslint-disable-next-line import/no-extraneous-dependencies
import DonutChart from 'foremanReact/components/common/charts/DonutChart';

const OmahaDonutChart = ({
  data
}) => {
  const { columns, search } = data;
  return <DonutChart data={columns} onclick={(e) => {
    if(search && search[e.id]) {
      window.location.href = search[e.id]
    }
  }} />
}

export default OmahaDonutChart;
