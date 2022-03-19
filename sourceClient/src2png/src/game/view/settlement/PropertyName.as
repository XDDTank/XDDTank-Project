// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.settlement.PropertyName

package game.view.settlement
{
    import flash.display.MovieClip;

    public class PropertyName extends MovieClip 
    {

        public static const DAMAGE:String = "damage";
        public static const AGILITY:String = "agility";
        public static const LUCY:String = "lucy";
        public static const ARMOR:String = "armor";
        public static const HP:String = "hp";
        public static const BROWN:int = 1;
        public static const BLUE:int = 2;
        public static const GREEN:int = 3;
        public static const RED:int = 4;
        public static const BLUE_BUTTON:int = 5;

        private var _type:int = 1;


        public function setType(_arg_1:String, _arg_2:int):void
        {
            this._type = _arg_2;
            gotoAndStop(_arg_1);
            var _local_3:int = ((currentFrame + _arg_2) - 1);
            gotoAndStop(_local_3);
        }

        public function get type():int
        {
            return (this._type);
        }


    }
}//package game.view.settlement

