/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */

moj.Helpers.personGenerator = (function(moj, $, Handlebars){
  "use strict";

  var MultiplePersons = function($personsContainer, template, maxPersons){
    this.$personsContainer = $personsContainer;
    this.template = template;
    this.maxPersons = maxPersons;
  };

  MultiplePersons.prototype = {
    /** Creates all person blocks
     */
    createPersonBlocks: function(){
      var a;

      this.$personsContainer.empty();

      for(a=1; a<=this.maxPersons; a++){
        this.createPersonBlock(a);
      }

      this.$personsContainer.find('>.sub-panel').hide();
    },

    /** Creates a single person block
     */
    createPersonBlock: function(personNumber){
      if (this.template) {
        var template = Handlebars.compile(this.template),
          html = template({id: personNumber, number: personNumber}),
          $block = $(html);

        if(personNumber>1){
          $block.addClass('same-address');
        }

        this.idFix($block, personNumber);
        $block.appendTo(this.$personsContainer);
      }
    },

    /**
     * There seems to be a bug in labelling form builder: when you specify an id for a text field
     * (using text_field_row), the "for" attribute on its label doesn't correspond to that ID.
     * The following is a temporary fix until the issue with the form builder is resolved.
     * Then we can use handlebars {{id}} and we can delete this function below.
     */
    idFix: function($block, blockNumber){
      $block.find('input, textarea').each(function(){
        $(this).attr('id', $(this).attr('id').replace('__id__', blockNumber));
      });

      $block.find('label').each(function(){
        $(this).attr('for', $(this).attr('for').replace('__id__', blockNumber));
      });
    }
  
  };

  return function($personsContainer, template, maxPersons){
    return new MultiplePersons($personsContainer, template, maxPersons);
  };

}(window.moj, window.$, window.Handlebars));
