// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.PhysicalObjFocusAnimation

package game.animations
{
    import phy.object.PhysicalObj;
    import game.objects.SimpleBomb;

    public class PhysicalObjFocusAnimation extends BaseSetCenterAnimation 
    {

        private var _phy:PhysicalObj;

        public function PhysicalObjFocusAnimation(_arg_1:PhysicalObj, _arg_2:int=100, _arg_3:int=0, _arg_4:int=1, _arg_5:int=-1)
        {
            super(_arg_1.x, (_arg_1.y + _arg_3), _arg_2, false, _arg_4, _arg_5);
            this._phy = _arg_1;
        }

        override public function canReplace(_arg_1:IAnimate):Boolean
        {
            var _local_2:PhysicalObjFocusAnimation = (_arg_1 as PhysicalObjFocusAnimation);
            if (((_local_2) && (!(_local_2._phy == this._phy))))
            {
                if (((this._phy is SimpleBomb) && (_local_2._phy is SimpleBomb)))
                {
                    if (((!(this._phy.isLiving)) || (SimpleBomb(this._phy).info.Id > SimpleBomb(_local_2._phy).info.Id)))
                    {
                        return (true);
                    };
                    return (false);
                };
            };
            return (true);
        }


    }
}//package game.animations

