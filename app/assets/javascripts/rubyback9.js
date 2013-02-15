_.templateSettings = {
    interpolate: /\[\%\=(.+?)\%\]/g,
    evaluate: /\[\%(.+?)\%\]/g
};
$(function(){
  /* Models */
  var Solution = Backbone.Model.extend({
    url: function() {
      return '/API' + (this.id ? '/solutions/' + this.id : '/solutions')
    }
  });
  var Hole = Backbone.Model.extend({
    url : function() {
      return '/API' + (this.id ? '/holes/' + this.id : '/holes'); 
    }
  });
  var Course = Backbone.Model.extend({
    url: function() {
      return '/API' + (this.id ? '/courses/' + this.id : '/courses'); 
    }
  });
  
  /* Collections */
  var SolutionList = Backbone.Collection.extend({
    model: Solution,
    initialize: function(models, options){
      this.hole_id = options.hole_id;
    },
    url: function() {
      return '/API/solutions?hole_id='+this.hole_id;
    }
  });
  var HoleList = Backbone.Collection.extend({
    model: Hole,
    initialize: function(models, options){
      this.course_id = options.course_id;
    },
    url: function() {
      return '/API/holes?course_id='+this.course_id; 
    }
  });
  var CourseList = Backbone.Collection.extend({
    model: Course,
    url: function() {
      return '/API/courses'; 
    }
  });
  
  /* Views */
  var CourseListItemView = Backbone.View.extend({
    tagName: 'li',
    className: 'course',
    template: _.template($('#courselistitem-template').html()),
    events: {
      "click .open-course" : "open"
    },
    open: function() {
      var activeCourse = new Course({id: this.model.get('id')});
      var courseDetail = new CourseDetailView({model: activeCourse});
      $('#message').show();
      activeCourse.fetch();
      $('li.course').removeClass('active');
      this.$el.addClass('active');
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.listenTo(this.model, 'change', this.render)
    }
  });
  var CourseDetailView = Backbone.View.extend({
    el: $('#course .course'),
    template: _.template($('#coursedetail-template').html()),
    render: function() {
      //Clear up all the views before we render the course detail
      $('#hole').empty();
      $('#course .course').empty();
      $('ul.holes').empty();
      
      //Render the course detail from the template
      this.$el.html(this.template(this.model.toJSON()));
      
      //Render all the holes on the right-hand navigation
      this.holes.each(function(hole){
        var holeListItem = new HoleListItemView({model: hole});
        $('ul.holes').append(holeListItem.render().el);
      });
      
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.holes = new HoleList({}, {course_id: this.model.get('id')});
      
      //Re-render when the holes collection or the course changes
      this.listenTo(this.model, 'change', this.render);
      this.listenTo(this.holes, 'reset', this.render)
      $('#message').show();
      
      //Fetch the holes collection for this course
      this.holes.fetch();
    }
  });
  var HoleListItemView = Backbone.View.extend({
    tagName: "li",
    className: "hole",
    template: _.template($('#holelistitem-template').html()),
    events: {
      "click .open-hole" : "open"
    },
    open: function() {
      if(holeDetail) {
        //Drop the hole event handlers before we re-render the hole view
        holeDetail.remove()
      }
      activeHole = new Hole({id: this.model.get('id')});
      holeDetail = new HoleDetailView({model: activeHole});
      $('#message').show();
      activeHole.fetch();
      $('li.hole').removeClass('active');
      this.$el.addClass('active');
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('#message').hide();
      return this;
    },
    initialize: function() {
      //Re-render on model change
      this.listenTo(this.model, 'change', this.render)
    }
  });
  var HoleDetailView = Backbone.View.extend({
    el: $('#hole'),
    template: _.template($('#holedetail-template').html()),
    solution_template: _.template($('#solution-template').html()),
    events: {
      "click .submit": "submitSolution",
      "keyup textarea": "updateScore"
    },
    updateScore: function() {
      //Update the score count while the user types
      $('.score').html($('.solution .input textarea').val().replace(/\s+/g, '').length)
    },
    submitSolution: function() {
      $('.solution .progress').show();
      
      //Create a new solution from the user's code
      var solution = new Solution({
        code: $('.solution .input textarea').val(),
        hole_id: this.model.get('id')
      });
      
      //Add the solution to the list when the server responds
      this.listenTo(solution, 'change', function(solution){
        this.user_solutions.add(solution);
      });
      solution.save();
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('.solution .output').empty();
      var self = this;
      this.user_solutions.each(function(solution){
        //Add solutions in reverse order so that newest is first
        $('.solution .output').prepend(self.solution_template(solution.toJSON()))
      });
      $('#message').hide();
      return this;
    },
    render_solutions: function() {
      var self = this;
      
      $('.solution .progress').hide();
      $('.solution .output').empty();
      this.user_solutions.each(function(solution){
        $('.solution .output').prepend(self.solution_template(solution.toJSON()))
      });
      $('#message').hide();
    },
    remove: function() {
        this.undelegateEvents();
        this.$el.empty();
        return this;
    },
    initialize: function() {
      //The user's solutions to this hole
      this.user_solutions = new SolutionList({}, {hole_id: this.model.get('id')});
      
      //Re-render hole if model changes
      this.listenTo(this.model, 'change', this.render);
      
      //Re-render solutions if user_solutions changes
      this.listenTo(this.user_solutions, 'reset', this.render_solutions);
      this.listenTo(this.user_solutions, 'add', this.render_solutions);
      
      this.user_solutions.fetch();
    }
  });
  var AppView = Backbone.View.extend({
    el: $('#application'),
    initialize: function() {
      var courses = new CourseList;
      this.listenTo(courses, 'reset', this.start);
      $('#message').show();
      courses.fetch();
    },
    start: function(courses) {
      courses.each(function(course){
        var courseListItem = new CourseListItemView({model: course});
        $('ul.courses').append(courseListItem.render().el);
      }, this);
    }
  })
  
  var activeHole, holeDetail;
  
  //Start the app
  var app = new AppView;
});