import React from 'react';
import PropTypes from 'prop-types';
// eslint-disable-next-line import/no-extraneous-dependencies
import DonutChart from 'foremanReact/components/common/charts/DonutChart';

const OmahaDonutChart = ({ data: { columns, search } }) => (
  <DonutChart
    data={columns}
    config="small"
    onclick={e => {
      if (search && search[e.id]) {
        window.location.href = search[e.id];
      }
    }}
  />
);

OmahaDonutChart.propTypes = {
  data: PropTypes.object.isRequired,
};

export default OmahaDonutChart;
