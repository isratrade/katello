/**
 * Copyright 2014 Red Hat, Inc.
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
 * @name  Bastion.content-views.controller:ErrataFilterListController
 *
 * @requires $scope
 * @requires translate
 * @requires Nutupane
 * @requires Filter
 * @requires Rule
 *
 * @description
 *   Handles displaying a list of errata currently added to the filter and the ability
 *   to remove errata from the filter.
 */
angular.module('Bastion.content-views').controller('ErrataFilterListController',
    ['$scope', 'translate', 'Nutupane', 'Filter', 'Rule',
    function ($scope, translate, Nutupane, Filter, Rule) {
        var nutupane;

        $scope.nutupane = nutupane = new Nutupane(Filter, {
                filterId: $scope.$stateParams.filterId,
                'order': 'issued DESC'
            },
            'errata'
        );

        $scope.detailsTable = nutupane.table;

        $scope.removeErrata = function () {
            var errataIds = nutupane.getAllSelectedResults('errata_id').included.ids,
                rules;

            nutupane.table.working = true;
            rules = findRules(errataIds);

            angular.forEach(rules, function (rule) {
                rule.$delete(success, failure);
            });
        };

        $scope.errataFilter = function () {
            return true;
        };

        function success(rule) {
            nutupane.removeRow(rule['errata_id'], 'errata_id');
            $scope.filter.rules = _.reject($scope.filter.rules, function (filterRule) {
                return rule.id === filterRule.id;
            });
            $scope.$parent.successMessages = [translate('Errata successfully removed.')];
        }

        function failure(response) {
            $scope.$parent.errorMessages = [response.data.displayMessage];
        }

        function findRules(errataIds) {
            var rules = [];

            angular.forEach(errataIds, function (id) {
                var found;

                found = _.find($scope.filter.rules, function (rule) {
                    return (rule['errata_id'] === id);
                });

                if (found) {
                    rules.push(new Rule(found));
                }
            });

            return rules;
        }

    }]
);
