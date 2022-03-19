// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.NoHoleEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class NoHoleEffectIcon extends BaseMirariEffectIcon 
    {

        public function NoHoleEffectIcon()
        {
            _iconClass = "asset.game.notDigAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.NoHole);
        }


    }
}//package game.view.effects

