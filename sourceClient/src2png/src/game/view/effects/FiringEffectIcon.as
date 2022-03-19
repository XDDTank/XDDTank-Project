// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.FiringEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class FiringEffectIcon extends BaseMirariEffectIcon 
    {

        public static const MIRARI_TYPE:int = 2;

        public function FiringEffectIcon()
        {
            _iconClass = "asset.game.fireAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.Firing);
        }


    }
}//package game.view.effects

