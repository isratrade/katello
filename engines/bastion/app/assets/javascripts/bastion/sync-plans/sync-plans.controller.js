/**
 * Copyright 2014  Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public
 * License as published by the Free Software Foundation; either version
 * 2 of the License (GPLv2) or (at your option) any later version.
 * There is NO WARRANTY for this software, express or implied,
 * including the implied warranties of MERCHANTABILITY,
 * NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 * have received a copy of GPLv2 along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 */

/**
 * @ngdoc object
 * @name  Bastion.syncPlans.controller:SyncPlansController
 *
 * @requires $scope
 * @requires $location
 * @requires translate
 * @requires Nutupane
 * @requires SyncPlan
 * @requires CurrentOrganization
 *
 * @description
 *   Provides the functionality specific to Sync Plans for use with the Nutupane UI pattern.
 *   Defines the columns to display and the transform function for how to generate each row
 *   within the table.
 */
angular.module('Bastion.sync-plans').controller('SyncPlansController',
    ['$scope', '$location', 'translate', 'Nutupane', 'SyncPlan', 'CurrentOrganization',
        function ($scope, $location, translate, Nutupane, SyncPlan, CurrentOrganization) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            var params = {
                'organization_id':  CurrentOrganization,
                'search':           $location.search().search || "",
                'order':            'name ASC'
            };

            var nutupane = new Nutupane(SyncPlan, params);
            $scope.syncPlanTable = nutupane.table;
            $scope.removeRow = nutupane.removeRow;
            $scope.nutupane = nutupane;

            nutupane.enableSelectAllResults();

            if ($location.search()['select_all']) {
                nutupane.table.selectAllResults(true);
            }

            $scope.syncPlanTable.closeItem = function () {
                $scope.transitionTo('sync-plans.index');
            };

            $scope.table = $scope.syncPlanTable;

            $scope.removeSyncPlan = function (syncPlan) {
                syncPlan.$remove(function () {
                    $scope.successMessages.push(translate('Sync Plan %s has been deleted.').replace('%s', syncPlan.name));
                    $scope.removeRow(syncPlan.id);
                    $scope.transitionTo('sync-plans.index');
                });
            };
        }]
);
