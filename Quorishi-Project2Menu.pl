#NQ-BCS316
#Final Project - Project 2
use strict;
use warnings;
use Text::CSV;
use Term::Menus;
use Term::ANSIColor qw(colored);

my $csv = Text::CSV->new( { binary => 1 } ) or die "Cannot use CSV: " . Text::CSV->error_diag();
my $file = "vgsales.csv";
my $fh;

# Open the CSV file for reading
open( $fh, "<", $file ) or die "Cannot open $file: $!";

# Read the CSV file into an array of arrays
my @data;
while ( my $row = $csv->getline($fh) ) {
    push @data, $row;
}
close $fh;

# Display menu to user
my $menu = new Term::Menus;
$menu->clear_screen(1);
$menu->mask_chars('*');
$menu->format(undef, '*', 2, 4);
$menu->title("Video Game Sales");
$menu->subtitle("Select an option:");
$menu->add_options(
    '1' => 'Sales for the world',
    '2' => 'Top sales by Platform',
    '3' => 'Top sales by Genre',
    '4' => 'Top sales by Publisher',
    '5' => 'Top sales by Platform given the year',
    '6' => 'Top sales by Genre given the year',
    '7' => 'Game with the lowest sales',
    '8' => 'Game with the highest sales',
    '9' => 'Platform with the lowest and highest sales',
    '10' => 'Publisher with the lowest and highest sales',
    '11' => 'Year with highest sales',
    '12' => 'Year with the lowest sales',
    'q' => 'Quit'
);

while (1) {
    my $user_choice = $menu->menu();
    last if ( $user_choice eq 'q' );

    # For 'Sales for the world':
    if ( $user_choice == 1 ) {
        my $world_sales = 0;
        foreach my $row (@data) {
            my $sales = $row->[10];
            $world_sales += $sales;
        }
        print "World Sales: " . colored("$world_sales", 'bold') . "\n";
    }

    # For 'Top sales by Platform':
    elsif ( $user_choice == 2 ) {
        my %platform_sales;
        foreach my $row (@data) {
            my $platform = $row->[2];
            my $sales = $row->[10];
            $platform_sales{$platform} += $sales;
        }
        print "Top sales by Platform:\n";
        foreach my $platform ( sort { $platform_sales{$b} <=> $platform_sales{$a} } keys %platform_sales ) {
            print colored("$platform: $platform_sales{$platform}\n", 'bold');
        }
    }

    # For 'Top sales by Genre':
    elsif ( $user_choice == 3 ) {
        my %genre_sales;
        foreach my $row (@data) {
            my $genre = $row->[4];
            my $sales = $row->[10];
            $genre_sales{$genre} += $sales;
        }
        print "Top sales by Genre:\n";
        foreach my $genre ( sort { $genre_sales{$b} <=> $genre_sales{$a} } keys %genre_sales ) {
            print colored("$genre: $genre_sales{$genre}\n", 'bold');
        }
    }

    # For 'Top sales by Publisher':
    elsif ( $user_choice == 4 ) {
        my %publisher_sales;
        foreach my $row (@data) {
            my $publisher = $row->[5];
            my $sales = $row->[10];
            $publisher_sales{$publisher} += $sales;
        }
        print "Top sales by Publisher:\n";
        foreach my $publisher ( sort { $publisher_sales{$b} <=> $publisher_sales{$a} } keys %publisher_sales ) {
        print colored("$publisher: $publisher_sales{$publisher}\n", 'bold');
        }
    }

    # For 'Top sales by Platform given the year':
    elsif ( $user_choice == 5 ) {
        print "Enter a year (e.g. 2006): ";
        my $year = <STDIN>;
        chomp $year;
            my %platform_sales;
        foreach my $row (@data) {
            my $platform = $row->[2];
            my $sales    = $row->[10];
            my $row_year = $row->[3];
            if ( $row_year eq $year ) {
                $platform_sales{$platform} += $sales;
            }
        }

        print "Top sales by Platform in $year:\n";
        foreach my $platform ( sort { $platform_sales{$b} <=> $platform_sales{$a} } keys %platform_sales ) {
            print colored("$platform: $platform_sales{$platform}\n", 'bold');
        }
    }

    # For 'Top sales by Genre given the year':
    elsif ( $user_choice == 6 ) {
        print "Enter a year (e.g. 2006): ";
        my $year = <STDIN>;
        chomp $year;

        my %genre_sales;
        foreach my $row (@data) {
            my $genre    = $row->[4];
            my $sales    = $row->[10];
            my $row_year = $row->[3];
            if ( $row_year eq $year ) {
                $genre_sales{$genre} += $sales;
            }
        }

        print "Top sales by Genre in $year:\n";
        foreach my $genre ( sort { $genre_sales{$b} <=> $genre_sales{$a} } keys %genre_sales ) {
            print colored("$genre: $genre_sales{$genre}\n", 'bold');
        }
    }

    # For 'Game with the lowest sales':
    elsif ( $user_choice == 7 ) {
        my $lowest_sales = 9999999999;
        my $game_title = "";
        foreach my $row (@data) {
            my $sales = $row->[10];
            if ( $sales < $lowest_sales ) {
                $lowest_sales = $sales;
                $game_title = $row->[1];
            }
        }
        print "Game with the lowest sales: " . colored("$game_title: $lowest_sales\n", 'bold');
    }

    # For 'Game with the highest sales':
    elsif ( $user_choice == 8 ) {
        my $highest_sales = 0;
        my $game_title = "";
        foreach my $row (@data) {
            my $sales = $row->[10];
            if ( $sales > $highest_sales ) {
                $highest_sales = $sales;
                $game_title = $row->[1];
            }
        }
        print "Game with the highest sales: " . colored("$game_title: $highest_sales\n", 'bold');
    }

    #For 'Platform with the lowest and highest sales':
    elsif ( $user_choice == 9 ) {
        my %platform_sales;
        foreach my $row (@data) {
            my $platform = $row->[2];
            my $sales = $row->[10];
            $platform_sales{$platform} += $sales;
        }
        my @platforms = sort { $platform_sales{$a} <=> $platform_sales{$b} } keys %platform_sales;
        print "Platform with the lowest sales: " . colored("$platforms[0]: $platform_sales{$platforms[0]}\n", 'bold');
        print "Platform with the highest sales: " . colored("$platforms[-1]: $platform_sales{$platforms[-1]}\n", 'bold');
    }

    # For 'Publisher with the lowest and highest sales':
    elsif ( $user_choice == 10 ) {
        my %publisher_sales;
        foreach my $row (@data) {
            my $publisher = $row->[5];
            my $sales = $row->[10];
            $publisher_sales{$publisher} += $sales;
        }
        my @publishers = sort { $publisher_sales{$a} <=> $publisher_sales{$b} } keys %publisher_sales;
        print "Publisher with the lowest sales: " . colored("$publishers[0]: $publisher_sales{$publishers[0]}\n", 'bold');
        print "Publisher with the highest sales: " . colored("$publishers[-1]: $publisher_sales{$publishers[-1]}\n", 'bold');
    }

    # For 'Year with highest sales':
    elsif ( $user_choice == 11 ) {
        my %year_sales;
        foreach my $row (@data) {
            my $year = $row->[3];
            my $sales = $row->[10];
            $year_sales{$year} += $sales;
        }
        my $max_year_sales = (reverse sort {$year_sales{$a} <=> $year_sales{$b}} keys %year_sales)[0];
        print "Year with highest sales: " . colored("$max_year_sales\n", 'bold');
    }

    # For 'Year with the lowest sales':
    elsif ( $user_choice == 12 ) {
        my %year_sales;
        foreach my $row (@data) {
            my $year = $row->[3];
            my $sales = $row->[10];
            $year_sales{$year} += $sales;
        }
        my $min_year_sales = (sort {$year_sales{$a} <=> $year_sales{$b}} keys %year_sales)[0];
        print "Year with lowest sales: " . colored("$min_year_sales\n", 'bold');
    }
    else {
        print "Invalid choice, please try again\n";
    }
}