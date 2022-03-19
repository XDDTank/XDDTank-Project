// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.DefendEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class DefendEffectIcon extends BaseMirariEffectIcon 
    {

        public function DefendEffectIcon()
        {
            _iconClass = "asset.game.shieldAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.Defend);
        }


    }
}//package game.view.effects

