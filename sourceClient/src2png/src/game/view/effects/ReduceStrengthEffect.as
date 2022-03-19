// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.ReduceStrengthEffect

package game.view.effects
{
    import game.objects.MirariType;
    import game.model.Living;

    public class ReduceStrengthEffect extends BaseMirariEffectIcon 
    {

        public var strength:int;

        public function ReduceStrengthEffect()
        {
            _iconClass = "asset.game.tiredAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.ReduceStrength);
        }

        override protected function excuteEffectImp(_arg_1:Living):void
        {
            _arg_1.energy = this.strength;
            super.excuteEffectImp(_arg_1);
        }


    }
}//package game.view.effects

