unit module Recipr::Log::Timeline;
use Log::Timeline;

class Processing does Log::Timeline::Task['Recipr', 'Processing', 'Processing']
is export { }

class Emitting does Log::Timeline::Task['Recipr', 'Backend', 'Emitting']
                 is export { }

class Saving does Log::Timeline::Task['Recipr', 'Processing', 'Saving']
               is export { }
class Ingredient does Log::Timeline::Task['Recipr', 'Processing', 'Ingredient']
             is export { }