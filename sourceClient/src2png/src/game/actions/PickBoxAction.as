// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.PickBoxAction

package game.actions
{
    import phy.object.PhysicalObj;
    import game.objects.SimpleBox;
    import game.objects.GameTurnedLiving;

    public class PickBoxAction 
    {

        public var executed:Boolean = false;
        private var _time:int;
        private var _boxid:int;

        public function PickBoxAction(_arg_1:int, _arg_2:int)
        {
            this._time = _arg_2;
            this._boxid = _arg_1;
        }

        public function get time():int
        {
            return (this._time);
        }

        public function execute(_arg_1:GameTurnedLiving):void
        {
            this.executed = true;
            var _local_2:PhysicalObj = _arg_1.map.getPhysical(this._boxid);
            if ((_local_2 is SimpleBox))
            {
                SimpleBox(_local_2).pickByLiving(_arg_1.info);
            };
        }


    }
}//package game.actions

