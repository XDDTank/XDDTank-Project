// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.SmallLiving

package game.view.smallMap
{
    import phy.object.SmallObject;
    import game.model.Living;
    import flash.display.Graphics;

    public class SmallLiving extends SmallObject 
    {

        protected var _info:Living;


        public function set info(_arg_1:Living):void
        {
            this._info = _arg_1;
            this.fitInfo();
        }

        public function get info():Living
        {
            return (this._info);
        }

        override protected function draw():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginFill(_color);
            _local_1.drawCircle(0, 0, _radius);
            _local_1.endFill();
        }

        protected function fitInfo():void
        {
            switch (this._info.team)
            {
                case 1:
                    color = 13260;
                    return;
                case 2:
                    color = 0xFF0000;
                    return;
                case 3:
                    color = 0xFFCC00;
                    return;
                case 4:
                    color = 0x99CC00;
                    return;
                case 5:
                    color = 6697932;
                    return;
                case 6:
                    color = 10053171;
                    return;
                case 7:
                    color = 16751052;
                    return;
                case 8:
                default:
                    color = 3381606;
            };
        }


    }
}//package game.view.smallMap

