// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ICharacterLoaderFactory

package ddt.view.character
{
    import ddt.data.player.PlayerInfo;

    public interface ICharacterLoaderFactory 
    {

        function createLoader(_arg_1:PlayerInfo, _arg_2:String="show"):ICharacterLoader;

    }
}//package ddt.view.character

