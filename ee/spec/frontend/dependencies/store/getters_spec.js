import * as getters from 'ee/dependencies/store/getters';
import { REPORT_STATUS } from 'ee/dependencies/store/constants';

describe('Dependencies getters', () => {
  describe.each`
    getterName         | reportStatus                    | outcome
    ${'isJobNotSetUp'} | ${REPORT_STATUS.jobNotSetUp}    | ${true}
    ${'isJobNotSetUp'} | ${REPORT_STATUS.ok}             | ${false}
    ${'isJobFailed'}   | ${REPORT_STATUS.jobFailed}      | ${true}
    ${'isJobFailed'}   | ${REPORT_STATUS.noDependencies} | ${true}
    ${'isJobFailed'}   | ${REPORT_STATUS.ok}             | ${false}
    ${'isIncomplete'}  | ${REPORT_STATUS.incomplete}     | ${true}
    ${'isIncomplete'}  | ${REPORT_STATUS.ok}             | ${false}
  `('$getterName when report status is $reportStatus', ({ getterName, reportStatus, outcome }) => {
    it(`returns ${outcome}`, () => {
      expect(
        getters[getterName]({
          reportInfo: {
            status: reportStatus,
          },
        }),
      ).toBe(outcome);
    });
  });
});
