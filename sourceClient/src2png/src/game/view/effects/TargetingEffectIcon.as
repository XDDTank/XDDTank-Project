// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.TargetingEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class TargetingEffectIcon extends BaseMirariEffectIcon 
    {

        public function TargetingEffectIcon()
        {
            _iconClass = "asset.game.TargetingAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.Targeting);
        }


    }
}//package game.view.effects

