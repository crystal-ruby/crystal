
# A Space is a collection of pages. It stores objects, the data for the objects,
# not references. See Page for more detail.

# Pages are stored by the object size they represent in a hash.

# Space and Page work together in making *new* objects available.
# "New" is slightly misleading in that normal operation only ever
# recycles objects.

module Parfait
  class Space < Object

    # ObjectSpace
    # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
  end
end
