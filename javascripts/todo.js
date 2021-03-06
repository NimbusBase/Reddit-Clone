// Generated by CoffeeScript 1.6.3
(function() {
  window.todo = angular.module('ToDo', []).controller('ToDoControl', function($scope) {
    $scope.items = [];
    $scope.searchText = "";
    $scope.items.push("a1");
    $scope.items.push("a2");
    $scope.items.push("a3");
    $scope.addItem = function() {
      var v;
      v = $scope.input_val;
      $scope.items.push(v);
      return $scope.input_val = "";
    };
    $scope.editItem = function() {
      var i;
      i = $scope.edit_index;
      $scope.items[i] = $scope.edit_val;
      $scope.edit_index = "";
      return $scope.edit_val = "";
    };
    $scope.deleteItem = function() {
      var t;
      t = $scope.delete_index;
      $scope.items.splice(t, 1);
      return $scope.delete_index = "";
    };
    return null;
  }).directive("nbclick", function() {
    return {
      restrict: 'AE',
      link: function(scope, elm, attrs) {
        return elm.bind('click', function(evt) {
          evt.preventDefault();
          scope.addItem();
          return scope.$parent.$apply();
        });
      }
    };
  });

}).call(this);
