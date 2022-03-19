// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.motions.ScreenMotionManager

package game.motions
{
    import road7th.data.DictionaryData;

    public class ScreenMotionManager 
    {

        private var _motions:DictionaryData;


        public function addMotion(_arg_1:BaseMotionFunc):void
        {
        }

        public function removeMotion(_arg_1:BaseMotionFunc):void
        {
        }

        public function execute():void
        {
            var _local_1:BaseMotionFunc;
            for each (_local_1 in this._motions)
            {
                _local_1.getResult();
            };
        }


    }
}//package game.motions

