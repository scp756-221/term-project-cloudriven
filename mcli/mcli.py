"""
Simple command-line interface to music service
"""

# Standard library modules
import argparse
import cmd
import re

# Installed packages
import requests

# The services check only that we pass an authorization,
# not whether it's valid
DEFAULT_AUTH = 'Bearer A'


def parse_args():
    argp = argparse.ArgumentParser(
        'mcli',
        description='Command-line query interface to music service'
    )
    argp.add_argument(
        'music_server',
        help="DNS name or IP address of music server"
    )
    argp.add_argument(
        'playlist_server',
        help="DNS name or IP address of playlist server"
    )
    argp.add_argument(
        'music_port',
        type=int,
        help="Port number of music server"
    )
    argp.add_argument(
        'playlist_port',
        type=int,
        help="Port number of playlist server"
    )
    return argp.parse_args()


def get_music_url(name, port):
    return "http://{}:{}/api/v1/music/".format(name, port)


def get_playlist_url(name, port):
    return "http://{}:{}/api/v1/playlist/".format(name, port)


def parse_quoted_strings(arg):
    """
    Parse a line that includes words and '-, and "-quoted strings.
    This is a simple parser that can be easily thrown off by odd
    arguments, such as entries with mismatched quotes.  It's good
    enough for simple use, parsing "-quoted names with apostrophes.
    """
    mre = re.compile(r'''(\w+)|'([^']*)'|"([^"]*)"''')
    args = mre.findall(arg)
    return [''.join(a) for a in args]


class Mcli(cmd.Cmd):
    def __init__(self, args):
        self.music_server = args.music_server
        self.music_port = args.music_port
        self.playlist_server = args.playlist_server
        self.playlist_port = args.playlist_port
        cmd.Cmd.__init__(self)
        self.prompt = 'mql: '
        self.intro = """
Command-line interface to music and playlist service.
Enter 'help' for command list.
'Tab' character autocompletes commands.
"""

    def do_read_music(self, arg):
        """
        Read a single song or list all songs.

        Parameters
        ----------
        song:  music_id (optional)
            The music_id of the song to read. If not specified,
            all songs are listed.

        Examples
        --------
        read_music 6ecfafd0-8a35-4af6-a9e2-cbd79b3abeea
            Return "The Last Great American Dynasty".
        read
            Return all songs (if the server supports this).

        Notes
        -----
        Some versions of the server do not support listing
        all songs and will instead return an empty list if
        no parameter is provided.
        """
        url = get_music_url(self.music_server, self.music_port)
        r = requests.get(
            url+arg.strip(),
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)
        items = r.json()
        if 'Count' not in items:
            print("0 items returned")
            return
        print("{} items returned".format(items['Count']))
        for i in items['Items']:
            print("{}  {:20.20s} {}".format(
                i['music_id'],
                i['Artist'],
                i['SongTitle']))

    def do_create_music(self, arg):
        """
        Add a song to the database.

        Parameters
        ----------
        artist: string
        title: string

        Both parameters can be quoted by either single or double quotes.

        Examples
        --------
        create_music 'Steely Dan'  "Everyone's Gone to the Movies"
            Quote the apostrophe with double-quotes.

        create_music Chumbawamba Tubthumping
            No quotes needed for single-word artist or title name.
        """
        url = get_music_url(self.music_server, self.music_port)
        args = parse_quoted_strings(arg)
        payload = {
            'Artist': args[0],
            'SongTitle': args[1]
        }
        r = requests.post(
            url,
            json=payload,
            headers={'Authorization': DEFAULT_AUTH}
        )
        print(r.json())

    def do_delete_music(self, arg):
        """
        Delete a song.

        Parameters
        ----------
        song: music_id
            The music_id of the song to delete.

        Examples
        --------
        delete_music 6ecfafd0-8a35-4af6-a9e2-cbd79b3abeea
            Delete "The Last Great American Dynasty".
        """
        url = get_music_url(self.music_server, self.music_port)
        r = requests.delete(
            url+arg.strip(),
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    # This part is not required for the project
    # def do_test(self, arg):
    #     """
    #     Run a test stub on the music server.
    #     """
    #     url = get_url(self.name, self.port)
    #     r = requests.get(
    #         url+'test',
    #         headers={'Authorization': DEFAULT_AUTH}
    #         )
    #     if r.status_code != 200:
    #         print("Non-successful status code:", r.status_code)

    def do_shutdown(self, arg):
        """
        Tell the music cerver to shut down.
        """
        url = get_music_url(self.music_server, self.music_port)
        r = requests.get(
            url+'shutdown',
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_create_playlist(self, arg):
        """
        Create a new playlist, and add default songs to the this list.

        Parameters
        ----------
        PlaylistName: string
            The name of the new playlist.
        Content: string
            A List of music strings.
        Example
        ----------
        create_playlist Chopin
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        args = parse_quoted_strings(arg)
        payload = {
            'PlaylistName': args[0],
            'Content': args[1],
        }
        r = requests.post(
            url,
            json=payload,
            headers={'Authorization': DEFAULT_AUTH}
        )
        print(r.json())
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_read_playlist(self, arg):
        """
        Read a playlist and display its content (PlaylistName name and its musics).
        Parameters
        ----------
        playlist_id: int
            The playlist_id of the playlist to read.
        Example
        ----------
        read_playlist 49206bf0-ad4e-11ec-b909-0242ac120002
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        r = requests.get(
            url+arg.strip(),
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)
        items = r.json()
        if 'Count' not in items:
            print("0 items returned")
            return
        print("{} items returned".format(items['Count']))
        for i in items['Items']:
            print("{}  {:20.20s} {}".format(
                i['playlist_id'],
                i['PlaylistName'],
                i['Content']))

    def do_edit_name(self, arg):
        """
        Edit the name of a playlist.
        Parameters
        ----------
        playlist_id: int (uuid)
            The playlist_id of the playlist to update, in quotation marks.
        PlaylistName: string
            The new name of the target playlist.
        Example
        ----------
        edit_name "8cca5ccb-44cb-4bdd-9a09-5ef082e397e5" Schubert
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        args = parse_quoted_strings(arg)
        payload = {
            'playlist_id': args[0],
            'PlaylistName': args[1]
        }
        r = requests.put(
            url,
            json=payload,
            headers={'Authorization': DEFAULT_AUTH}
        )
        print(r.json())
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_delete_playlist(self, arg):
        """
        Delete a playlist.
        Parameters
        ----------
        playlist_id: int
            The playlist_id of the playlist to delete.
        Example
        ----------
        delete_playlist 8cca5ccb-44cb-4bdd-9a09-5ef082e397e5
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        r = requests.delete(
            url+arg.strip(),
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_add_song(self, arg):
        """
        Add a song to a playlist.
        Parameters
        ----------
        playlist: playlist_id
            The playlist_id of the playlist to update.
        song: music_id
            The song to be appended to the playlist.
        Examples
        --------
        append 91246583-ced8-4d70-8f5e-ce81419bb63c 862a897c-0fa9-4a18-9a5b-77661528dde8
            add_song "Moonlight" to "Beethoven".
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        args = parse_quoted_strings(arg)
        r = requests.post(
            url+f'{args[0]}/add',
            json={'music_id': args[1]},
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_remove_song(self, arg):
        """
        Remove a song from a playlist.
        Parameters
        ----------
        playlist: playlist_id
            The playlist_id of the playlist to update.
        song: music_id
            The song to be removed from the playlist.
        Examples
        --------
        add 91246583-ced8-4d70-8f5e-ce81419bb63c 862a897c-0fa9-4a18-9a5b-77661528dde8
            remove_song "Moonlight" from "Beethoven".
        """
        url = get_playlist_url(self.playlist_server, self.playlist_port)
        args = parse_quoted_strings(arg)
        r = requests.post(
            url+f'{args[0]}/delete',
            json={'music_id': args[1]},
            headers={'Authorization': DEFAULT_AUTH}
        )
        if r.status_code != 200:
            print("Non-successful status code:", r.status_code)

    def do_quit(self, arg):
        """
        Quit the program.
        """
        return True


if __name__ == '__main__':
    args = parse_args()
    Mcli(args).cmdloop()
