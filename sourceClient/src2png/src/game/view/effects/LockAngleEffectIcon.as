// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.LockAngleEffectIcon

package game.view.effects
{
    import game.objects.MirariType;
    import game.model.Living;

    public class LockAngleEffectIcon extends BaseMirariEffectIcon 
    {

        public function LockAngleEffectIcon()
        {
            _iconClass = "asset.game.lockAngelAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.LockAngl);
        }

        override protected function excuteEffectImp(_arg_1:Living):void
        {
            _arg_1.isLockAngle = true;
            super.excuteEffectImp(_arg_1);
        }

        override public function unExcuteEffect(_arg_1:Living):void
        {
            _arg_1.isLockAngle = false;
        }


    }
}//package game.view.effects

