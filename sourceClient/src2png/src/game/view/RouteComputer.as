// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.RouteComputer

package game.view
{
    import phy.maps.Map;
    import phy.object.PhysicalObj;
    import game.GameManager;
    import flash.geom.Point;

    public class RouteComputer 
    {

        private static var DELAY_TIME:Number = 0.04;

        private var _map:Map;

        public function RouteComputer(_arg_1:Map)
        {
            this._map = _arg_1;
        }

        public function getPath(_arg_1:int, _arg_2:int):Array
        {
            var _local_3:PhysicalObj;
            _local_3 = new PhysicalObj(0, 1, 10, 70, 240, 1);
            _local_3.x = GameManager.Instance.Current.selfGamePlayer.pos.x;
            _local_3.y = GameManager.Instance.Current.selfGamePlayer.pos.y;
            _local_3.setSpeedXY(new Point(this.getVx(_arg_1, _arg_2), this.getVy(_arg_1, _arg_2)));
            _local_3.setCollideRect(-3, -3, 6, 6);
            this._map.addPhysical(_local_3);
            _local_3.startMoving();
            var _local_4:Array = [];
            while (_local_3.isMoving())
            {
                _local_4.push(new Point(_local_3.x, _local_3.y));
                _local_3.update(DELAY_TIME);
            };
            return (_local_4);
        }

        private function getVx(_arg_1:int, _arg_2:int):Number
        {
            return (_arg_2 * Math.cos(((_arg_1 / 180) * Math.PI)));
        }

        private function getVy(_arg_1:int, _arg_2:int):Number
        {
            return (_arg_2 * Math.sin(((_arg_1 / 180) * Math.PI)));
        }


    }
}//package game.view

