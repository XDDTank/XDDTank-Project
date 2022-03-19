// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.TiredEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class TiredEffectIcon extends BaseMirariEffectIcon 
    {

        public function TiredEffectIcon()
        {
            _iconClass = "asset.game.tiredAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.Tired);
        }


    }
}//package game.view.effects

