// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.DragMapAnimation

package game.animations
{
    public class DragMapAnimation extends BaseSetCenterAnimation 
    {

        public function DragMapAnimation(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=false, _arg_4:int=100, _arg_5:int=1, _arg_6:int=-1)
        {
            super(_arg_1, _arg_2, _arg_4, _arg_3, _arg_5, _arg_6);
        }

        override public function canAct():Boolean
        {
            return (!(_finished));
        }


    }
}//package game.animations

