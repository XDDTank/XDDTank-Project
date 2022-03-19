// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.DisenableFlyEffectIcon

package game.view.effects
{
    import game.objects.MirariType;
    import game.model.Living;

    public class DisenableFlyEffectIcon extends BaseMirariEffectIcon 
    {

        public function DisenableFlyEffectIcon()
        {
            _iconClass = "asset.game.forbidFlyAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.DisenableFly);
        }

        override protected function excuteEffectImp(_arg_1:Living):void
        {
            _arg_1.isLockFly = true;
            super.excuteEffectImp(_arg_1);
        }

        override public function unExcuteEffect(_arg_1:Living):void
        {
            _arg_1.isLockFly = false;
        }


    }
}//package game.view.effects

