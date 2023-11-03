/**
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * This schedule run every day
 * do call menthod TrialLinkService.Create
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @author         Diky 
 * @modifiedBy     ...
 * @maintainedBy   ...
 * @version        1.0
 * @created        2021-06-25
 * @modified       YYYY-MM-DD
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @changes
 * vX.X            ...
 * YYYY-MM-DD      ...
 *
 */
global class Schedule_TrialLinkCreation implements Schedulable{

	  global void execute(SchedulableContext sc) {
          TrialLinkServices trialLinkServicesObject = new TrialLinkServices();
          trialLinkServicesObject.createTrialLinkConversionRecords();
     }
}