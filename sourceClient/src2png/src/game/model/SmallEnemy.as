// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.SmallEnemy

package game.model
{
    import ddt.events.LivingEvent;

    [Event(name="modelChanged", type="tank.events.LivingEvent")]
    public class SmallEnemy extends Living 
    {

        private var _modelID:int;

        public function SmallEnemy(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        public function set modelID(_arg_1:int):void
        {
            var _local_2:int = this._modelID;
            this._modelID = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.MODEL_CHANGED, this._modelID, _local_2));
        }

        public function get modelID():int
        {
            return (this._modelID);
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package game.model

